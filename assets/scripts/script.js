$(() => {
  $(".container").each((index, element) => {
    element.addEventListener('wheel', event => {
      event.preventDefault();
      element.scrollBy({
        left: event.deltaY < 0 ? -50 : 50,
      });
    })
  })

  $(".timeline-node").each((index, element) => {
    element.addEventListener('mouseover', (event) => {
      event.preventDefault();
      $(".timeline-circle").eq(index).addClass("timeline-circle-hover");
    });
    element.addEventListener('mouseout', event => {
      event.preventDefault();
      $(".timeline-circle").eq(index).removeClass("timeline-circle-hover");
    })
  });
});

function togglePopup() {
  const popup = $('#popup-card');
  popup.css('display', (popup.css('display') === 'none' || popup.css('display') === '') ? 'flex' : 'none');
}
