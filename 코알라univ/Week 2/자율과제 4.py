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