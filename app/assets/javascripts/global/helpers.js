/**
 * Mainly used for submitting the form in another language
 * @param url
 */
function submitFormTo(url) {
    var form = $('form');
    form.attr('action', url)
    form.submit()
}
