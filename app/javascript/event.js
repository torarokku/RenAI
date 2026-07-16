export function initEvent() {

  const popup = document.getElementById("event-popup")

  if (!popup) return

  const message = popup.dataset.message

  if (!message) return

  popup.textContent = message

  popup.classList.add("show")

  setTimeout(() => {

    popup.classList.remove("show")

  }, 2500)

}