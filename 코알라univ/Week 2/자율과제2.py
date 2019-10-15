
birth = input("생년월일을 6자리로 입력해주세오. (yymmdd): ")
print("-" * 30)
yr = birth[:2]; mon = birth[2:4]; day = birth[4:6]
print("당신의 생일은 " + yr + "년 " + mon, "월", day, "일입니다.")