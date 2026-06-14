# Flutter UI Widget Separation Guideline

## Mục tiêu

Xây dựng UI Flutter:

- Dễ đọc
- Dễ bảo trì
- Dễ mở rộng
- Dễ tái sử dụng
- Dễ làm việc nhóm

---

# Nguyên tắc cốt lõi

> Một widget chỉ nên có một trách nhiệm rõ ràng.

Không nên viết toàn bộ UI trong một `build()` dài hàng trăm dòng.

Ví dụ:

```text
ProductDetailScreen
├── ProductImage
├── ProductInfo
├── ProductPrice
├── ProductRating
└── AddToCartButton
```

---

# Khi nào nên tách widget?

Tách widget khi:

- UI có nhiều dòng code
- Có thể tái sử dụng
- Có chức năng riêng
- Có state riêng
- Làm build() quá dài

Ví dụ:

```text
ProductCard
CartItem
SearchBarWidget
OrderSummary
LoginForm
ProfileHeader
```

---

# Nguyên tắc tách widget

## 1. Tách theo khu vực giao diện

```text
ProductDetailScreen
├── ProductImage
├── ProductInfo
├── ProductPrice
└── AddToCartButton
```

Mỗi widget phụ trách một vùng giao diện.

---

## 2. Tách theo chức năng

Ví dụ Login:

```text
LoginTitle
EmailInput
PasswordInput
ForgotPasswordLink
LoginButton
```

---

## 3. Tách phần UI lặp lại

Không làm:

```dart
Card(...)
Card(...)
Card(...)
```

Nên làm:

```dart
ProductCard(product: product)
```

---

# Method hay Widget?

## Method

Dùng khi:

- UI nhỏ
- Chỉ dùng trong một màn hình

```dart
Widget buildTitle() {
  return const Text("Login");
}
```

---

## Widget Class

Ưu tiên cho project thật.

```dart
class LoginTitle extends StatelessWidget {
  const LoginTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("Login");
  }
}
```

Ưu điểm:

- Reuse tốt
- Dễ test
- Dễ bảo trì

---

# Cấu trúc thư mục đề xuất

```text
lib/
└── features/
    ├── auth/
    │   ├── screens/
    │   ├── widgets/
    │   └── services/
    │
    ├── product/
    │   ├── screens/
    │   ├── widgets/
    │   ├── models/
    │   └── repositories/
    │
    └── cart/
        ├── screens/
        ├── widgets/
        └── services/
```

Tổ chức theo feature thay vì theo loại file.

---

# Quy tắc truyền dữ liệu

❌ Không nên:

```dart
ProductCard(
  id: id,
  name: name,
  image: image,
  price: price,
  rating: rating,
)
```

✅ Nên:

```dart
ProductCard(
  product: product,
)
```

Khi tham số quá nhiều, hãy truyền model.

---

# Business Logic

Widget chỉ chịu trách nhiệm hiển thị UI.

❌ Không nên:

```dart
onPressed: () async {
  await api.login();
}
```

✅ Nên:

```text
Widget
↓
Bloc / Provider / ViewModel
↓
Service
↓
Repository
↓
API
```

---

# Những lỗi phổ biến

## Tách quá nhỏ

Không cần:

```dart
class WelcomeText extends StatelessWidget {}
class Spacer16 extends StatelessWidget {}
```

nếu chỉ dùng một lần.

---

## build() quá dài

Không nên:

```dart
build() {
  // 300+ dòng
}
```

Hãy chia nhỏ thành widget.

---

## Trộn UI và Logic

Không nên:

```text
Widget
├── API Call
├── Validation
└── UI
```

Nên:

```text
UI
↓
State Management
↓
Service
↓
Repository
↓
API
```

---

# Checklist Review Code

Trước khi tạo Pull Request:

- [ ] Widget có một trách nhiệm duy nhất
- [ ] build() dễ đọc
- [ ] UI lặp lại đã được tách
- [ ] Không có business logic trong widget
- [ ] Tên widget rõ nghĩa
- [ ] Theo cấu trúc feature
- [ ] Reuse widget khi có thể
- [ ] Không tách widget quá mức

---

# Quy tắc cuối cùng

Nếu một phần UI:

- Có ý nghĩa riêng
- Có thể tái sử dụng
- Có chức năng riêng

=> Hãy tách thành widget riêng.

Mục tiêu cuối cùng:

- Clean Code
- Reusable UI
- Maintainable Code
- Scalable Architecture