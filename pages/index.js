import Link from '@/components/Link'
import { PageSEO } from '@/components/SEO'
import siteMetadata from '@/data/siteMetadata'
import { getCategories } from '@/lib/mdx'

export async function getStaticProps() {
  const categories = getCategories()
  return { props: { categories } }
}

export default function Home({ categories }) {
  return (
    <>
      <PageSEO title={siteMetadata.title} description={siteMetadata.description} />
      <div className="divide-y divide-gray-200 dark:divide-gray-700">
        <div className="pt-6 pb-8 space-y-2 md:space-y-5">
          <h1 className="text-3xl font-extrabold leading-9 tracking-tight text-gray-900 dark:text-gray-100 sm:text-4xl sm:leading-10 md:text-6xl md:leading-14">
            Available Workshops
          </h1>
          <p className="text-lg leading-7 text-gray-500 dark:text-gray-400">
            {siteMetadata.description}
          </p>
        </div>
        <ul className="divide-y divide-gray-200 dark:divide-gray-700">
          {!categories.length && <li className="py-6">No workshops found.</li>}
          {categories.map(({ slug, title }) => (
            <li key={slug} className="py-6">
              <article className="space-y-2 xl:grid xl:grid-cols-4 xl:space-y-0 xl:items-baseline">
                <div className="space-y-5 xl:col-span-3">
                  <div>
                    <h2 className="text-2xl font-bold leading-8 tracking-tight">
                      <Link
                        href={`/${slug}`}
                        className="text-gray-900 dark:text-gray-100 hover:text-primary-800 dark:hover:text-primary-400"
                      >
                        {title}
                      </Link>
                    </h2>
                  </div>
                  <div className="text-base font-medium leading-6">
                    <Link
                      href={`/${slug}`}
                      className="text-primary-800 dark:text-primary-700 hover:text-primary-900 dark:hover:text-primary-400"
                      aria-label={`View ${title}`}
                    >
                      View workshop &rarr;
                    </Link>
                  </div>
                </div>
              </article>
            </li>
          ))}
        </ul>
      </div>
    </>
  )
}
