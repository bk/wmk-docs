const toc_toggle = document.getElementById('toc-toggle');
const toc = document.getElementById('toc');

function toggle_toc () {
  if (! (toc && toc_toggle)) return;
  if (toc.classList.contains('hide-0')) {
    toc.classList.remove('hide-0');
    toc_toggle.innerHTML = 'Hide TOC &nbsp;&#x25bc;';
  }
  else {
    toc.classList.add('hide-0');
    toc_toggle.innerHTML = 'Show TOC &nbsp;&#x25ba;';
  }
}
