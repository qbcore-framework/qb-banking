const wrapper = document.getElementById("root")

const sendMessageToFrame = (iframe, message) => iframe.contentWindow.postMessage(message, "*")

window.addEventListener("message", (evt) => {
    const currentFrame = document.getElementById('bankingFrame')

    if (evt.data.action === 'close') {
        wrapper.style.display = "none"
        sendMessageToFrame(currentFrame, evt.data)
        currentFrame.remove()
    } else if (evt.data.action === 'open' && evt.data.type && ['atm', 'bank'].includes(evt.data.type)) {
        const iframe = document.createElement("iframe")

        wrapper.style.display = "block"
        iframe.src = `${evt.data.type}/index.html`
        iframe.setAttribute("id", "bankingFrame")
        iframe.setAttribute("target", evt.data.type)
        iframe.addEventListener("load", () => {
            sendMessageToFrame(iframe, evt.data)
        })
        
        return wrapper.appendChild(iframe)
    } else {
        return sendMessageToFrame(currentFrame, evt.data)
    }
})
