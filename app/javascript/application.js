// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"

import { initCharacter } from "./character"
import { initMessage } from "./message"
import { initAffection } from "./affection"
import { initBackground } from "./background"
import { initEvent } from "./event"

document.addEventListener("turbo:load", () => {
  initCharacter()
  initMessage()
  initAffection()
  initBackground()
  initEvent()
})