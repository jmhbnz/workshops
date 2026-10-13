import kebabCase from '@/lib/utils/kebabCase'

const Tag = ({ text }) => {
  return (
    (<div className="mr-3 text-sm font-medium uppercase text-primary-800">{text.split(' ').join('-')}</div>)
  );
}

export default Tag
