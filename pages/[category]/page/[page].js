import fs from 'fs'
import path from 'path'
import { PageSEO } from '@/components/SEO'
import siteMetadata from '@/data/siteMetadata'
import { getAllFilesFrontMatter } from '@/lib/mdx'
import ListLayout from '@/layouts/ListLayout'

const POSTS_PER_PAGE = 10

export async function getStaticPaths() {
  const dataDir = path.join(process.cwd(), 'data')
  const categories = fs.readdirSync(dataDir).filter((file) =>
    fs.statSync(path.join(dataDir, file)).isDirectory()
  )

  const paths = []

  for (const category of categories) {
    const totalPosts = await getAllFilesFrontMatter(category)
    const totalPages = Math.ceil(totalPosts.length / POSTS_PER_PAGE)
    for (let i = 1; i <= totalPages; i++) {
      paths.push({
        params: { category, page: i.toString() },
      })
    }
  }

  return {
    paths,
    fallback: false,
  }
}

export async function getStaticProps(context) {
  const { category, page } = context.params
  const posts = await getAllFilesFrontMatter(category)
  const postsWithCategory = posts.map((post) => ({
    ...post,
    slug: `${category}/${post.slug}`,
  }))
  const pageNumber = parseInt(page)
  const initialDisplayPosts = posts.slice(
    POSTS_PER_PAGE * (pageNumber - 1),
    POSTS_PER_PAGE * pageNumber
  )
  const pagination = {
    currentPage: pageNumber,
    totalPages: Math.ceil(posts.length / POSTS_PER_PAGE),
  }

  return {
    props: {
      posts: postsWithCategory,
      initialDisplayPosts,
      pagination,
      category,
    },
  }
}

export default function PostPage({ posts, initialDisplayPosts, pagination, category }) {
  return (
    <>
      <PageSEO title={siteMetadata.title} description={siteMetadata.description} />
      <ListLayout
        posts={posts}
        initialDisplayPosts={initialDisplayPosts}
        pagination={pagination}
        title={`All exercises (${category})`}
      />
    </>
  )
}
