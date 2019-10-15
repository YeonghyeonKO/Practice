#자율과제 1
print("일반계산기 프로그램입니다!")
one = int(input("계산할 첫 번째 값을 입력해주세요 : "))
two = int(input("계산할 첫 번째 값을 입력해주세요 : "))
print("\n")

print("두 개의 값 : ", one, "와", two, "\n")

print("더하기 값 (a + b) : ", one + two)
print("빼기 값 (a - b) : ", one - two)
print("곱하기 값 (a * b) : ", one * two)
print("정수 나누기 값 (a // b) : ", one // two)
print("실수 나누기 값 (a // b) : ", one / two)
print("정수 나누기 값 (a % b) : ", one % two)



# 자율과제 2
birth = input("생년월일을 6자리로 입력해주세오. (yymmdd): ")
print("-" * 30)
yr = birth[:2]; mon = birth[2:4]; day = birth[4:6]
print("당신의 생일은 " + yr + "년 " + mon, "월", day, "일입니다.")


# 자율과제 3
for i in range(10):
    print("*" * i)

print("\n")

for i in range(6):
    print("*" * (2 * i-1))

# for i in range(1, 11, 2):
#    print("*" * i)

print("\n")

for i in range(10):
    print("*" * (10 - i))

# for i in range(1, 11):
#    print("*" * (11 - i))


# 자율과제 4
players = ["황의조", "황희찬", "구자철", "이재성", "기성용"]

print("현재 경기 중인 선수: ")
for i in players:
    print(i)

print("*" * 30)

del_num = int(input("OUT 시킬 선수 번호: "))
new = input("IN 할 선수 이름: ")

del players[del_num]
players.append(new)

print("*" * 30, "\n교체결과: ")

for i in players:
    print(i)