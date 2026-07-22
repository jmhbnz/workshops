import Zoom from 'react-medium-image-zoom'
import 'react-medium-image-zoom/dist/styles.css'

const ZoomableImage = ({ alt, ...props }) => (
  <Zoom>
    <div>
      <img
        loading="lazy"
        decoding="async"
        alt={alt}
        {...props}
        className="rounded-lg"
      />
    </div>
  </Zoom>
)

export default ZoomableImage
