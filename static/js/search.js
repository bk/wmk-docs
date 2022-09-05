const feedback = document.getElementById('results');
const searchfield = document.getElementById('searchfield');

async function do_search () {
    let url = new URL(document.location);
    let query = url.searchParams.get('q');
    let idx = {};
    let summaries = {};
    if (! query) {
        feedback.innerHTML = 'Please enter your search terms above';
        return;
    } else {
        searchfield.value = query;
        document.title = 'Search results: ' + query;
        feedback.innerHTML = 'Just a moment... performing search';
    }
    try {
        const resp = await fetch('/idx.summaries.json');
        if (!resp.ok) {
            throw new Error(`HTTP error for summaries': ${resp.status}`);
        }
        summaries = await resp.json();
    }
    catch (error) {
        console.error(`Error in fetching summaries: ${error}`)
    }
    try {
        const resp = await fetch('/idx.json');
        if (!resp.ok) {
            throw new Error(`HTTP error for idx': ${resp.status}`);
        }
        idx = await resp.json();
    }
    catch (error) {
        console.error(`Error in fetching index: ${error}`)
    }
    if (idx && summaries) {
        show_results(query, idx, summaries)
    }
    else {
        feedback.innerHTML = 'An ERROR occurred';
    }
}

function show_results(query, idx, summaries) {
    const res = lunr.Index.load(idx).search(query);
    if (! res.length) {
        feedback.innerHTML = 'Nothing was found.';
        return;
    }
    let html = '<ul>';
    for (const el of res) {
        const sum = summaries[el.ref];
        html += `<li><a href="${el.ref}">${sum.title}</a> ${sum.summary}...</li>`;
    }
    html += '</ul>';
    feedback.innerHTML = html;
}
