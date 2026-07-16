export function initCharacter() {
  const character = document.getElementById("character-image")

  if (!character) return

  requestAnimationFrame(() => {
    character.classList.add("show")
  })

  character.addEventListener(
    "transitionend",
    () => {
      character.classList.add("float")
    },
    { once: true }
  )
}