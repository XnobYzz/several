// author: XIE

let ntns = document.querySelector('#azt-asc-time-picker');
let nsme = '01-01-2000'; // thay đổi thành ngày tháng năm sinh bản thân | định dạng: ngày-tháng-năm
ntns.value = nsme;
let event = new Event('input', { bubbles: true });
ntns.dispatchEvent(event);
var button = document.querySelector('button[azt-track-service="setting-general-CDosWd3k63"]');
if (button) {
    button.click();
}

// thay đổi ngày tháng năm sinh: azota.vn
