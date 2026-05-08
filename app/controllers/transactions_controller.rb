class TransactionsController < ApplicationController
  # B1: Bắt buộc phải đăng nhập mới được dùng các tính năng này
  before_action :authenticate_user!
  
  # B2: Sửa lại set_transaction để chỉ tìm trong phạm vi giao dịch của CHÍNH người đó
  before_action :set_transaction, only: %i[ show edit update destroy ]

  # GET /transactions
  def index
  # 1. Lấy toàn bộ giao dịch của user (để tính toán)
  user_transactions = current_user.transactions
  
  # 2. Dữ liệu cho biểu đồ 
  @chart_data = user_transactions.group(:category).sum(:amount)
  
  # 3. Dữ liệu cho danh sách 
  @transactions = user_transactions.order(transaction_date: :desc)
  end

  # GET /transactions/1
  def show
  end

  # GET /transactions/new
  def new
    # Khởi tạo một giao dịch mới thuộc về current_user
    @transaction = current_user.transactions.build
  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions
  def create
    # Tạo giao dịch mới và tự động gán user_id = current_user.id
    @transaction = current_user.transactions.build(transaction_params)

    respond_to do |format|
      if @transaction.save
        format.html { redirect_to transactions_path, notice: "Đã thêm khoản chi mới!" }
        format.json { render :show, status: :created, location: @transaction }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transactions/1
  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to transactions_path, notice: "Đã cập nhật giao dịch." }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1
  def destroy
    @transaction.destroy!

    respond_to do |format|
      format.html { redirect_to transactions_path, notice: "Đã xóa giao dịch.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # QUAN TRỌNG: Chỉ cho phép tìm giao dịch TRONG DANH SÁCH CỦA USER ĐANG ĐĂNG NHẬP
    # Nếu User A cố tình nhập ID của User B lên thanh địa chỉ, Rails báo Not Found 
    # thay vì hiện dữ liệu của người khác 
    def set_transaction
      @transaction = current_user.transactions.find(params[:id])
    end

    def transaction_params
      params.require(:transaction).permit(:title, :amount, :category, :transaction_date)
    end
end