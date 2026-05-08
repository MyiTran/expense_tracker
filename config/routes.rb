Rails.application.routes.draw do
  # Cấu hình cho việc đăng nhập/đăng ký (Devise)
  devise_for :users

  # Cấu hình các đường dẫn cho giao dịch (Index, New, Create, Edit, Update, Destroy)
  resources :transactions

  # Đặt trang chủ là trang danh sách chi tiêu
  # Khi bạn vào localhost:3000 nó sẽ tự chạy vào đây
  root "transactions#index"
end