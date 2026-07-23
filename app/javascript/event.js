export function initEvent() {

  const popup = document.getElementById("event-popup")

  if (!popup) return

  const message = popup.dataset.message

  if (!message) return

  switch (message) {

    case "clear":
      console.log("ok")
      popup.textContent = "🎉 CLEAR!!"
      console.log("ok")

      popup.classList.add("clear")

      setTimeout(() => {
        popup.textContent = "🏅 バッジ獲得！"
      }, 2000)

      document.getElementById("clear-overlay")
              .classList.add("show")

      break
  }

  const homePath = popup.dataset.homePath

  popup.classList.add("show")  

  setTimeout(() => {

    popup.classList.remove("show")
    popup.classList.remove("clear")

    document.getElementById("clear-overlay")
            .classList.remove("show")

  }, 2500)
    setTimeout(() => {
    window.location.href = homePath
  }, 3000)


}