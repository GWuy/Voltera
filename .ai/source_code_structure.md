# AI Code Review Instructions

Bạn đóng vai trò là một Senior Flutter Engineer và Technical Reviewer.

Hãy đọc toàn bộ source code của project Flutter và đánh giá theo rubric dưới đây.

## Mục tiêu

Không chỉ kiểm tra ứng dụng có chạy được hay không.

Hãy đánh giá:

- Kiến trúc project
- Chất lượng code
- Khả năng bảo trì
- Khả năng mở rộng
- State management
- Error handling
- Performance
- Coding convention
- Mức độ chuyên nghiệp của source code

---

# Rubric đánh giá

## 1. Cấu trúc project (10%)

Kiểm tra:

- Có chia thư mục theo feature không
- Có tách screen, widget, model, service, repository không
- Có tránh việc đặt quá nhiều code trong main.dart không
- Cấu trúc thư mục có dễ tìm kiếm và mở rộng không

Chấm điểm: 0-10

---

## 2. Chất lượng code (10%)

Kiểm tra:

- Tên biến có rõ nghĩa không
- Tên hàm có rõ nghĩa không
- Tên class có rõ nghĩa không
- Có đoạn code quá dài không
- Có code smell không
- Có duplicate code không

Chấm điểm: 0-10

---

## 3. Tách UI thành widget nhỏ (10%)

Kiểm tra:

- Mỗi màn hình có được chia thành các widget nhỏ không
- Widget có một trách nhiệm rõ ràng không
- Widget có khả năng tái sử dụng không
- Hàm build() có quá dài không

Chấm điểm: 0-10

---

## 4. Tách logic khỏi UI (10%)

Kiểm tra:

- Business logic có nằm trong widget không
- API call có nằm trực tiếp trong UI không
- Validation có nằm trong UI không
- Có service/repository/controller/viewmodel/provider không

Chấm điểm: 0-10

---

## 5. State Management (10%)

Kiểm tra:

- Đang dùng setState, Provider, Riverpod, Bloc hay GetX
- Có lạm dụng biến global không
- Loading state
- Error state
- Empty state
- Success state

Chấm điểm: 0-10

---

## 6. Navigation (8%)

Kiểm tra:

- Route management
- Deep navigation
- Truyền dữ liệu giữa màn hình
- Back navigation

Chấm điểm: 0-8

---

## 7. Model & Data Layer (8%)

Kiểm tra:

- Có model rõ ràng không
- Có fromJson/toJson không
- Có dùng Map<dynamic,dynamic> quá nhiều không
- Có type safety không

Chấm điểm: 0-8

---

## 8. Error Handling (8%)

Kiểm tra:

- try-catch
- API exception
- Form validation
- Null safety
- User-friendly error message

Chấm điểm: 0-8

---

## 9. Responsive UI (8%)

Kiểm tra:

- SafeArea
- Expanded
- Flexible
- ListView
- ScrollView
- Khả năng chạy trên nhiều kích thước màn hình

Chấm điểm: 0-8

---

## 10. Reusability & Constants (6%)

Kiểm tra:

- AppColors
- AppStrings
- AppRoutes
- AppSizes
- Shared Widgets

Chấm điểm: 0-6

---

## 11. Performance (6%)

Kiểm tra:

- const constructor
- ListView.builder
- API call placement
- Rebuild optimization
- Memory issues

Chấm điểm: 0-6

---

## 12. Testing & Stability (6%)

Kiểm tra:

- Manual testing
- Unit test
- Widget test
- Crash risk
- Runtime issues

Chấm điểm: 0-6

---

# Các lỗi nghiêm trọng cần phát hiện

Nếu tìm thấy hãy liệt kê riêng:

- Toàn bộ code nằm trong main.dart
- build() quá dài (>200 dòng)
- API call trong build()
- Không có model
- Dùng Map ở mọi nơi
- Copy-paste UI
- Không xử lý lỗi mạng
- Không có loading state
- Navigation lỗi
- RenderFlex overflow
- Hard-coded strings
- Hard-coded colors
- Hard-coded API URLs

---

# Kết quả đầu ra mong muốn

Xuất kết quả theo format sau:

## Tổng điểm

XX / 100

---

## Chi tiết từng tiêu chí

| Tiêu chí | Điểm | Nhận xét |
|-----------|-------|----------|
| Cấu trúc project | x/10 | |
| Chất lượng code | x/10 | |
| Tách widget | x/10 | |
| Tách logic khỏi UI | x/10 | |
| State management | x/10 | |
| Navigation | x/8 | |
| Model & Data | x/8 | |
| Error Handling | x/8 | |
| Responsive UI | x/8 | |
| Reusability | x/6 | |
| Performance | x/6 | |
| Testing | x/6 | |

---

## Điểm mạnh

Liệt kê tối thiểu 5 điểm mạnh.

---

## Điểm yếu

Liệt kê tối thiểu 10 điểm yếu.

---

## Các file cần refactor gấp

Liệt kê theo mức độ ưu tiên:

HIGH
MEDIUM
LOW

---

## Đề xuất cải thiện

Cho roadmap cải thiện theo thứ tự:

1. Việc cần làm ngay
2. Việc nên làm trong sprint tiếp theo
3. Việc nên làm khi mở rộng hệ thống

---

## Đánh giá cuối cùng

Cho biết trình độ source code tương ứng:

- Fresher
- Junior
- Junior+
- Mid-level
- Mid-level+
- Senior

và giải thích lý do.