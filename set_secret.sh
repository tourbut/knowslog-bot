#!/bin/bash

# .dev.vars 파일 확인
if [ ! -f .dev.vars ]; then
    echo "Error: .dev.vars file not found!"
    echo "Please copy .dev.vars.example to .dev.vars and fill in your secrets."
    exit 1
fi

echo "Reading secrets from .dev.vars..."

# 파일을 줄 단위로 읽기
while IFS='=' read -r key value; do
    # 주석(#)이나 빈 줄 무시
    [[ $key =~ ^#.*$ ]] || [[ -z $key ]] && continue
    
    # 값에 있는 따옴표 제거 (선택 사항, 필요에 따라 조정)
    value=${value%\"}
    value=${value#\"}
    
    # 키가 존재하면 wrangler secret put 실행
    if [ ! -z "$key" ]; then
        echo "Setting secret: $key"
        # echo "$value" | npx wrangler secret put "$key" # wrangler v2/v3 호환성 확인 필요
        # 일부 wrangler 버전에서는 stdin 입력을 위해 --name 등의 플래그가 다를 수 있으나, 표준적인 방법 사용
        echo "$value" | npx wrangler secret put "$key"
    fi
done < .dev.vars

echo "All secrets processed."
