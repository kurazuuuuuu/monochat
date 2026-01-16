import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list", "form", "input", "submit", "error", "charCount"]
  static values = { spaceUuid: String }

  connect() {
    this.loadMessages()
    this.startPolling()
    this.updateCharCount()
  }

  disconnect() {
    this.stopPolling()
  }

  // メッセージ一覧を読み込み
  async loadMessages() {
    try {
      const response = await fetch(`/spaces/${this.spaceUuidValue}/messages`, {
        headers: {
          'Accept': 'application/json'
        }
      })

      if (!response.ok) {
        throw new Error('Failed to load messages')
      }

      const messages = await response.json()
      this.renderMessages(messages)
    } catch (error) {
      console.error('Error loading messages:', error)
      this.showError('メッセージの読み込みに失敗しました')
    }
  }

  // メッセージを送信
  async sendMessage(event) {
    event.preventDefault()

    const content = this.inputTarget.value.trim()
    if (!content) return

    // 送信ボタンを無効化
    this.submitTarget.disabled = true
    this.hideError()

    try {
      const response = await fetch(`/spaces/${this.spaceUuidValue}/messages`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-CSRF-Token': this.getCSRFToken()
        },
        body: JSON.stringify({
          message: { content }
        })
      })

      const data = await response.json()

      if (!response.ok) {
        if (response.status === 429) {
          // レート制限エラー
          this.showError(data.error)
          this.scheduleRetry(data.retry_after)
        } else {
          throw new Error(data.errors?.[0] || 'Failed to send message')
        }
        return
      }

      // 成功時: フォームをクリアしてメッセージを追加
      this.inputTarget.value = ''
      this.updateCharCount()
      this.appendMessage(data)
      this.scrollToBottom()

    } catch (error) {
      console.error('Error sending message:', error)
      this.showError(error.message || 'メッセージの送信に失敗しました')
    } finally {
      this.submitTarget.disabled = false
    }
  }

  // メッセージ一覧を描画
  renderMessages(messages) {
    this.listTarget.innerHTML = messages.map(msg => this.messageHTML(msg)).join('')
    this.scrollToBottom()
  }

  // メッセージを追加
  appendMessage(message) {
    this.listTarget.insertAdjacentHTML('beforeend', this.messageHTML(message))
  }

  // メッセージのHTML生成
  messageHTML(message) {
    const date = new Date(message.created_at)
    const timeStr = date.toLocaleTimeString('ja-JP', { hour: '2-digit', minute: '2-digit' })

    return `
      <div class="message-item" data-message-uuid="${message.message_uuid}">
        <div class="message-header">
          <span class="message-sender">${this.escapeHTML(message.sender_name)}</span>
          <span class="message-time">${timeStr}</span>
        </div>
        <div class="message-content">${this.escapeHTML(message.content)}</div>
      </div>
    `
  }

  // 文字数カウントを更新
  updateCharCount() {
    const length = this.inputTarget.value.length
    this.charCountTarget.textContent = `${length} / 500`
  }

  // ポーリング開始（5秒ごとに新しいメッセージをチェック）
  startPolling() {
    this.pollingInterval = setInterval(() => {
      this.pollNewMessages()
    }, 5000)
  }

  // ポーリング停止
  stopPolling() {
    if (this.pollingInterval) {
      clearInterval(this.pollingInterval)
    }
  }

  // 新しいメッセージをポーリング
  async pollNewMessages() {
    const lastMessageElement = this.listTarget.lastElementChild
    if (!lastMessageElement) return

    try {
      const response = await fetch(`/spaces/${this.spaceUuidValue}/messages`, {
        headers: { 'Accept': 'application/json' }
      })

      if (!response.ok) return

      const messages = await response.json()
      const currentUUIDs = new Set(
        Array.from(this.listTarget.children).map(el => el.dataset.messageUuid)
      )

      // 新しいメッセージのみ追加
      messages.forEach(msg => {
        if (!currentUUIDs.has(msg.message_uuid)) {
          this.appendMessage(msg)
        }
      })

      // 新しいメッセージがあればスクロール
      if (this.listTarget.children.length > currentUUIDs.size) {
        this.scrollToBottom()
      }
    } catch (error) {
      console.error('Error polling messages:', error)
    }
  }

  // 下部にスクロール
  scrollToBottom() {
    this.listTarget.scrollTop = this.listTarget.scrollHeight
  }

  // エラー表示
  showError(message) {
    this.errorTarget.textContent = message
    this.errorTarget.style.display = 'block'
  }

  // エラー非表示
  hideError() {
    this.errorTarget.style.display = 'none'
  }

  // リトライをスケジュール
  scheduleRetry(seconds) {
    setTimeout(() => {
      this.submitTarget.disabled = false
      this.hideError()
    }, seconds * 1000)
  }

  // CSRF トークン取得
  getCSRFToken() {
    const meta = document.querySelector('meta[name="csrf-token"]')
    return meta ? meta.content : ''
  }

  // HTML エスケープ
  escapeHTML(str) {
    const div = document.createElement('div')
    div.textContent = str
    return div.innerHTML
  }
}
