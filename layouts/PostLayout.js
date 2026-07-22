import Link from '@/components/Link'
import PageTitle from '@/components/PageTitle'
import SectionContainer from '@/components/SectionContainer'
import { BlogSEO } from '@/components/SEO'
import siteMetadata from '@/data/siteMetadata'
import ScrollTopAndComment from '@/components/ScrollTopAndComment'

export default function PostLayout({ frontMatter, next, prev, children }) {
  const { slug, title, exercise } = frontMatter

  return (
    <SectionContainer>
      <BlogSEO
        url={`${siteMetadata.siteUrl}/workshop/${slug}`}
        {...frontMatter}
      />

      <ScrollTopAndComment />

      <article>
        <div className="xl:divide-y xl:divide-gray-200 xl:dark:divide-gray-700">
          <header className="pt-6 xl:pb-6">
            <div className="space-y-1 text-center">
              <dl className="space-y-10">
                <div>
                  <dt className="sr-only">Exercise</dt>
                  <dd className="text-base font-medium leading-6 text-gray-500 dark:text-gray-400">
                    Exercise {exercise}
                  </dd>
                </div>
              </dl>

              <PageTitle>{title}</PageTitle>
            </div>
          </header>

          <div className="divide-y divide-gray-200 pb-8 dark:divide-gray-700 xl:grid xl:grid-cols-4 xl:gap-x-6 xl:divide-y-0">
            {/* Left navigation */}
            <aside className="pt-10 xl:col-span-1">
              {(next || prev) && (
                <div className="space-y-8 text-sm font-medium leading-5">
                  {prev && (
                    <div>
                      <h2 className="text-xs uppercase tracking-wide text-gray-500 dark:text-gray-400">
                        Previous Exercise
                      </h2>
                      <div className="text-primary-800 hover:text-primary-900 dark:hover:text-primary-400">
                        <Link href={`/workshop/${prev.slug}`}>
                          ← {prev.title}
                        </Link>
                      </div>
                    </div>
                  )}

                  {next && (
                    <div>
                      <h2 className="text-xs uppercase tracking-wide text-gray-500 dark:text-gray-400">
                        Next Exercise
                      </h2>
                      <div className="text-primary-800 hover:text-primary-900 dark:hover:text-primary-400">
                        <Link href={`/workshop/${next.slug}`}>
                          {next.title} →
                        </Link>
                      </div>
                    </div>
                  )}

                  <div className="pt-4">
                    <Link
                      href="/workshop"
                      className="text-primary-800 hover:text-primary-900 dark:hover:text-primary-400"
                    >
                      ← Back to exercise list
                    </Link>
                  </div>
                </div>
              )}
            </aside>

            {/* Workshop content */}
            <div className="xl:col-span-3">
              <div className="prose max-w-none pt-10 pb-8 dark:prose-dark">
                {children}
              </div>
            </div>
          </div>
        </div>
      </article>
    </SectionContainer>
  )
}
