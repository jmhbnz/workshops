/* eslint-disable react/display-name */
import { useMemo } from 'react'
import { getMDXComponent } from 'mdx-bundler/client'
import Image from './Image'
import ZoomableImage from './ZoomableImage'
import CustomLink from './Link'
import TOCInline from './TOCInline'
import Pre from './Pre'
import Quote from './Quote'
import YoutubeEmbed from './YoutubeEmbed'

import Zoom from 'react-medium-image-zoom'
import 'react-medium-image-zoom/dist/styles.css'

const MDXParagraph = ({ children }) => {
  const childrenArray = Array.isArray(children) ? children : [children]

  const hasBlockElement = childrenArray.some(
    (child) =>
      child?.type === ZoomableImage
  )

  if (hasBlockElement) {
    return <>{children}</>
  }

  return <p>{children}</p>
}

export const MDXComponents = {
  p: MDXParagraph,
  Image,
  img: ZoomableImage,
  TOCInline,
  a: CustomLink,
  pre: Pre,
  Quote,
  YoutubeEmbed,
  Zoom,
  wrapper: ({ components, layout, ...rest }) => {
    const Layout = require(`../layouts/${layout}`).default
    return <Layout {...rest} />
  },
}

export const MDXLayoutRenderer = ({ layout, mdxSource, ...rest }) => {
  const MDXLayout = useMemo(() => getMDXComponent(mdxSource), [mdxSource])

  return <MDXLayout layout={layout} components={MDXComponents} {...rest} />
}
