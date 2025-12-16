#!/bin/bash

# 현재 스크립트 파일의 이름을 가져옵니다 (자신을 삭제하지 않기 위해)
SCRIPT_NAME=$(basename "$0")

echo "=== 개별 파일 압축 및 검증 후 삭제를 시작합니다 ==="

# 현재 폴더의 모든 파일(*)에 대해 반복
for item in *; do
    # 1. 스크립트 파일 자신은 건너뜀
    if [[ "$item" == "$SCRIPT_NAME" ]]; then
        continue
    fi

    # 2. 이미 .7z 파일인 경우 건너뜀 (선택 사항)
    if [[ "$item" == *.7z ]]; then
        echo "[SKIP] $item 은(는) 이미 7z 파일입니다."
        continue
    fi

    echo "------------------------------------------------"
    echo "처리 중: $item"

    # 3. 압축 실행 (최대 압축률 -mx=9 적용)
    # "$item.7z" 로 파일명 생성
    7z a -mx=9 "${item}.7z" "$item" > /dev/null

    # 압축 성공 여부 확인 ($?는 바로 앞 명령의 종료 코드, 0이면 성공)
    if [ $? -eq 0 ]; then
        echo " -> 압축 완료. 검증(Verify) 시작..."

        # 4. 무결성 검증 실행
        7z t "${item}.7z" > /dev/null

        if [ $? -eq 0 ]; then
            echo " -> 검증 성공. 원본을 삭제합니다."

            # 5. 원본 삭제
            rm -rf "$item"
        else
            echo " -> [경고] 검증 실패! 원본을 삭제하지 않습니다: $item"
            # 실패한 7z 파일은 삭제하고 싶다면 아래 주석 해제
            # rm "${item}.7z"
        fi
    else
        echo " -> [오류] 압축 실패. 원본을 유지합니다: $item"
    fi
done

echo "------------------------------------------------"
echo "=== 모든 작업이 완료되었습니다 ==="
