'''
name = input("당신의 이름은? : ")
age = int(input("당신의 나이는? : "))

after = 100 - age
future = 2019 + after

print(name, "님은 ", future, "년에 100살이 됩니다.")

print("\n\n")
'''

menu = ["1. 김밥", "2. 떡볶이", "3. 우동", "4. 튀김", "5. 라면"]
price = [2500, 3500, 4000, 3500, 3000]

print("오늘의 메뉴")
for i in menu:
    print(i)

print("-" * 20)
num = input("어떤 메뉴를 선택할까요?:")
plates = int(input("몇 개를 주문할까요?:"))

print("-" * 20)

print("계산 금액은\n", price[int(num)-1] * plates)

