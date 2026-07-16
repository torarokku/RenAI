export function initMessage() {
  console.log("message.js 読み込み")

  const button = document.querySelector(".send-button")
  const messageWindow = document.getElementById("message-window")

  if (button) {
    button.addEventListener("click", () => {
      button.classList.add("pressed")

      setTimeout(() => {
        button.classList.remove("pressed")
      }, 150)
    })
  }

  if (messageWindow) {
    requestAnimationFrame(() => {
      messageWindow.classList.add("pop")

      setTimeout(() => {
        messageWindow.classList.remove("pop")
      }, 200)
    })

    messageWindow.scrollTo({
      top: messageWindow.scrollHeight,
      behavior: "smooth"
    })
  }
}