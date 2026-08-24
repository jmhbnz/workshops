import fs from 'fs'
import path from 'path'
import PageTitle from '@/components/PageTitle'
import generateRss from '@/lib/generate-rss'
import { MDXLayoutRenderer } from '@/components/MDXComponents'
import { formatSlug, getAllFilesFrontMatter, getFileBySlug, getFiles, getCategories } from '@/lib/mdx'

const DEFAULT_LAYOUT = 'PostLayout'

export async function getStaticPaths() {
  const categories = getCategories()

  const paths = categories.flatMap((cat) => {
    const posts = getFiles(cat.slug)
    return posts.map((p) => ({
      params: {
        category: cat.slug,
        slug: formatSlug(p).split('/'),
      },
    }))
  })

  return {
    paths,
    fallback: false,
  }
}

export async function getStaticProps({ params }) {
  const { category, slug } = params
  const slugPath = slug.join('/')

  const allPosts = await getAllFilesFrontMatter(category)
  const postIndex = allPosts.findIndex((post) => formatSlug(post.slug) === slugPath)

  const prevItem = allPosts[postIndex - 1] || null
  const nextItem = allPosts[postIndex + 1] || null

  const prev = prevItem ? { ...prevItem, slug: `${category}/${prevItem.slug}` } : null
  const next = nextItem ? { ...nextItem, slug: `${category}/${nextItem.slug}` } : null

  const post = await getFileBySlug(category, slugPath)

  if (allPosts.length > 0) {
    const rss = generateRss(allPosts)
    fs.writeFileSync(`./public/${category}-feed.xml`, rss)
  }

  return { props: { post, prev, next } }
}

export default function Workshop({ post, prev, next }) {
  const { mdxSource, toc, frontMatter } = post

  return (
    <>
      {frontMatter.draft !== true ? (
        <MDXLayoutRenderer
          layout={frontMatter.layout || DEFAULT_LAYOUT}
          toc={toc}
          mdxSource={mdxSource}
          frontMatter={frontMatter}
          prev={prev}
          next={next}
        />
      ) : (
        <div className="mt-24 text-center">
          <PageTitle>
            Under Construction{' '}
            <span role="img" aria-label="roadwork sign">
              🚧
            </span>
          </PageTitle>
        </div>
      )}
    </>
  )
}
