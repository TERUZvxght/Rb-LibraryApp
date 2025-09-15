class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy ]
  before_action :require_admin, only: %i[ new edit destroy ]

  # GET /books or /books.json
  def index
    @q          = params[:q]
    @from_on    = params[:from_on]
    @to_on      = params[:to_on]
    @min_amount = params[:min_amount]
    @max_amount = params[:max_amount]
    @sort       = params[:sort]
    @page       = (params[:page] || 1).to_i

    @result = BooksSearch.new(
      q: @q, from_on: @from_on, to_on: @to_on,
      min_amount: @min_amount, max_amount: @max_amount,
      sort: @sort, page: @page
    ).call

    sub = Loan.all.select("book_id, COUNT(*) AS cnt").group(:book_id)

    @books = @result.records
      .joins("LEFT JOIN (#{sub.to_sql}) AS x ON x.book_id = books.id")
      .where("books.amount > COALESCE(x.cnt, 0)")

    # @books = @result.records
  end

  # GET /books/1 or /books/1.json
  def show
    @current_count = @book.amount - Loan.where(book: @book, returned: false).count
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books or /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: "Book was successfully created." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: "Book was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    @book.destroy!

    respond_to do |format|
      format.html { redirect_to books_path, notice: "Book was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.expect(book: [ :title, :published_on, :author_id, :cover, :amount ])
    end
end
