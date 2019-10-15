a = "Hello"
b = 3
c = -11
print(type(a))

print(a)
print(b)
print(c)

print(a, b, c, a*3)

'''
name = input("이름을 입력해주세요: ")
age = input("나이를 입력해주세요: ")

print("이름은", name)
print("나이는", age)

g_age = int(age) - 1
print("만 나이는", g_age)
'''

# BMI 계산기
'''
height = input("키를 입력하세요 : ")
weight = input("몸무게를 입력하세요 : ")

height = int(height); weight = int(weight)

BMI = weight / (height * height) * 10000

print("BMI : ", BMI)
'''

string1 = "브이넥 라이트 다운 베스트"
string2 = "    25,990원   "

print(string1.replace("라이트", "헤비"))
print(string1)

string1 = string1.replace("라이트", "헤비")
print(string1)

print(string2.strip())
print(string2)

string2 = string2.strip()
string2 = string2.replace(",", "")[:-1]
print(string2)

players = ["황의조", "황희찬", "구자철", "이재성", "기성용"]

print(players)
print(len(players))

del players[3]
players.remove("황의조")
print(players)

print(players[0:2])
print(len(players[1]))  # "황희찬" 글자 수


MAX = 10

#3. range()안에 숫자가 세 개 들어가 있는 경우
for i in range(1, MAX, 2):  # 세 번째 인자는 간격을 의미한다.
    print(i)
    print("반복문을 배워 봅시다.")

players = ["황의조", "황희찬", "구자철", "이재성", "기성용"]

print("2019년 아시안컵 출전명단:")
for i in range(len(players)):
    print(players[i])

print("2019년 아시안컵 출전명단:")
for p in players:
    print(p)


## Challenge 2

data = ["조회수: 1,500", "조회수: 1,002", "조회수: 300", "조회수: 251",
        "조회수: 13,432", "조회수: 998"]
sum = 0
num = []

for i in range(len(data)):
    print(data[i])
    print(data[i][5:].replace(",", ""))
    num.append(int(data[i][5:].replace(",", "")))
    sum += num[i]
print("총 합 : ", sum)