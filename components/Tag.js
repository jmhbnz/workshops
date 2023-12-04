import Link from 'next/link'
import kebabCase from '@/lib/utils/kebabCase'

const Tag = ({ text }) => {
  return (
    (<Link
      href={`/tags/${kebabCase(text)}`}
      className="mr-3 text-sm font-medium uppercase text-primary-800 hover:text-primary-900 dark:hover:text-primary-400">

      {text.split(' ').join('-')}

    </Link>)
  );
}

export default Tag
