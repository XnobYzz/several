// author: XIE

// thay đổi thành ngày tháng năm sinh bản thân | định dạng: ngày-tháng-năm
let ntns = document.querySelector('#azt-asc-time-picker');
let nsme = '01-01-2000'; // thay đổi
ntns.value = nsme;
let event = new Event('input', { bubbles: true });
ntns.dispatchEvent(event);
// nhập tên người dùng
const tnd = document.getElementById('azt-acs-username');
tnd.removeAttribute('disabled');
tnd.value = 'xietestscript'; // thay đổi
var button = document.querySelector('button[azt-track-service="setting-general-CDosWd3k63"]');
if (button) {
    button.click();
}

// thay đổi thông tin tài khoản, ngày tháng năm sinh: azota.vn
