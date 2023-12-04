import Document, { Html, Head, Main, NextScript } from 'next/document'
class MyDocument extends Document {
  render() {
    return (
      <Html lang="en">
        <Head>
          <link rel="apple-touch-icon" sizes="180x180" href="/static/favicons/apple-touch-icon.png?v=2" />
          <link rel="icon" type="image/png" sizes="32x32" href="/static/favicons/favicon-32x32.png?v=2" />
          <link rel="icon" type="image/png" sizes="16x16" href="/static/favicons/favicon-16x16.png?v=2" />
          <link rel="manifest" href="/static/favicons/site.webmanifest?v=2" />
          <link rel="mask-icon" href="/static/favicons/safari-pinned-tab.svg?v=2" color="#5bbad5" />
          <link rel="shortcut icon" href="/static/favicons/favicon.ico?v=2" />
          <meta name="msapplication-TileColor" content="#2b5797" />
          <meta name="msapplication-config" content="/static/favicons/browserconfig.xml?v=2" />
          <meta name="theme-color" content="#ffffff" />
          <link rel="alternate" type="application/rss+xml" href="/feed.xml" />
          <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
          <link
            href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap"
            rel="stylesheet"
          />
          <link
            rel="stylesheet"
            href="https://cdn.jsdelivr.net/npm/katex@0.13.11/dist/katex.min.css"
            integrity="sha384-Um5gpz1odJg5Z4HAmzPtgZKdTBHZdw8S29IecapCSB31ligYPhHQZMIlWLYQGVoc"
            crossOrigin="anonymous"
          />
        </Head>
        <body className="antialiased text-black bg-white dark:bg-gray-900 dark:text-white">
          <Main />
          <NextScript />
        </body>
      </Html>
    )
  }
}

export default MyDocument
