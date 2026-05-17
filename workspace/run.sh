#!/bin/bash

SESSION_NAME="claude-agent"

if [ "$1" = "--discord" ]; then
    CLAUDE_CMD="claude --channels plugin:discord@claude-plugins-official --dangerously-skip-permissions"
else
    CLAUDE_CMD="claude --dangerously-skip-permissions"
fi

tmux has-session -t "$SESSION_NAME" 2>/dev/null

if [ $? != 0 ]; then
    echo "새로운 tmux 세션 '$SESSION_NAME'을 생성하고 Claude를 백그라운드에서 실행합니다..."

    # 백그라운드(-d) 모드로 새로운 tmux 세션 생성
    tmux new-session -d -s "$SESSION_NAME"

    # 생성된 세션에 Claude 명령어 전송 및 실행 (C-m은 Enter 키를 의미)
    tmux send-keys -t "$SESSION_NAME" "$CLAUDE_CMD" C-m

    echo "✅ 실행 완료!"
    echo "💡 진행 상황을 보려면 아래 명령어로 세션에 접속하세요:"
    echo "   tmux attach -t $SESSION_NAME"

else
    echo "⚠️ 이미 '$SESSION_NAME' 세션이 실행 중입니다."
    echo "💡 기존 세션에 접속하려면 아래 명령어를 입력하세요:"
    echo "   tmux attach -t $SESSION_NAME"
fi
