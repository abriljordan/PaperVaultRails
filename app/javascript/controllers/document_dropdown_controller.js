export default function toggleDocumentDropdown(id) {
  const dropdownMenu = document.getElementById(`document-dropdown-menu-${id}`);
  if (dropdownMenu) {
    dropdownMenu.classList.toggle('hidden');
    
    // Close other dropdowns
    document.querySelectorAll('[id^="document-dropdown-menu-"]').forEach(menu => {
      if (menu !== dropdownMenu) {
        menu.classList.add('hidden');
      }
    });
  }

  // Close dropdown when clicking outside
  document.addEventListener('click', function(event) {
    if (!event.target.closest(`#document-dropdown-${id}`) && !event.target.closest(`#document-dropdown-menu-${id}`)) {
      const dropdownMenu = document.getElementById(`document-dropdown-menu-${id}`);
      if (dropdownMenu) {
        dropdownMenu.classList.add('hidden');
      }
    }
  });
}
