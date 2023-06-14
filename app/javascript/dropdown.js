document.addEventListener('DOMContentLoaded', function() {
  var dropdownToggle = document.querySelector('.dropdown-toggle');
  var dropdownMenu = document.querySelector('.dropdown-menu');

  dropdownToggle.addEventListener('click', function() {
    dropdownMenu.style.display = (dropdownMenu.style.display === 'block') ? 'none' : 'block';
  });

  document.addEventListener('click', function(e) {
    var target = e.target;
    var isDropdownToggle = target.classList.contains('dropdown-toggle') || target.closest('.dropdown-toggle');

    if (!isDropdownToggle) {
      dropdownMenu.style.display = 'none';
    }
  });
});
