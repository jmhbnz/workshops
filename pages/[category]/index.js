import { getAllFilesFrontMatter, getCategories } from '@/lib/mdx'
import siteMetadata from '@/data/siteMetadata'
import ListLayout from '@/layouts/ListLayout'
import { PageSEO } from '@/components/SEO'

export const POSTS_PER_PAGE = 10

export async function getStaticPaths() {
  const categories = getCategories()

  return {
    paths: categories.map((cat) => ({
      params: { category: cat.slug },
    })),
    fallback: false,
  }
}

export async function getStaticProps({ params }) {
  const posts = await getAllFilesFrontMatter(params.category)
  const initialDisplayPosts = posts.slice(0, POSTS_PER_PAGE)
  const pagination = {
    currentPage: 1,
    totalPages: Math.ceil(posts.length / POSTS_PER_PAGE),
  }

  return {
    props: {
      initialDisplayPosts,
      posts,
      pagination,
      category: params.category
    }
  }
}

export default function CategoryIndex({ posts, initialDisplayPosts, pagination, category }) {
  return (
    <>
      <PageSEO title={`${siteMetadata.description}`} />
      <ListLayout
        posts={posts}
        initialDisplayPosts={initialDisplayPosts}
        pagination={pagination}
        title={`All exercises (${category})`}
      />
    </>
  )
}
