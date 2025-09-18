import { createConsumer } from "@rails/actioncable";

const url = document.querySelector('meta[name="action-cable-url"]')?.content || "/cable";
console.log("🔌 consumer connecting to:", url);

const consumer = createConsumer(url);
window.__CableConsumer__ = consumer;

export default consumer;
