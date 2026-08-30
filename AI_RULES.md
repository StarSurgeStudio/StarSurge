# StarSurge Website - Project Guidelines

## Tech Stack

- **Core Technology**: Vanilla HTML5, CSS3, and JavaScript (ES6+)
- **Build Tool**: Vite for development server and production builds
- **CSS Framework**: Bootstrap 4 for responsive layout and UI components
- **JavaScript Library**: jQuery for DOM manipulation and event handling
- **Database**: Supabase (PostgreSQL) for persistent data storage
- **Icons**: Font Awesome 5 for social media and UI icons
- **Typography**: Google Fonts (Gruppo, Lato, Staatliches)
- **Video Hosting**: CDN-hosted video content (e.g., Kapwing CDN)
- **Chat Integration**: Facebook Messenger Customer Chat Plugin

## Library Usage Rules

### CSS Styling

- **Primary CSS**: Edit `style.css` for custom styles
- **Bootstrap**: Use Bootstrap 4 utility classes for common layouts (grid, flexbox, spacing)
- **Avoid**: Overriding Bootstrap core files; use custom classes instead
- **Responsive**: Use Bootstrap's responsive breakpoints (col-md-*, col-lg-*, etc.)

### JavaScript

- **Main Script**: Edit `app.js` for custom JavaScript logic
- **jQuery**: Use jQuery for DOM manipulation, event handling, and AJAX
- **CDN Scripts**: Load external libraries via CDN in `index.html`
- **ES6+**: Write modern JavaScript with const/let, arrow functions, template literals
- **Module Pattern**: Use IIFE pattern for encapsulated code (see existing `app.js`)

### Database (Supabase)

- **Tables**: games, team_members, contact_messages (as defined in migrations)
- **Client**: Use Supabase JS client for database operations
- **Security**: Respect RLS policies; anon can read games/team_members, insert contact_messages
- **Authentication**: Required for reading/managing contact_messages

### External Dependencies

- **jQuery**: Always load before custom scripts that use it
- **Popper.js**: Required by Bootstrap 4 tooltips and dropdowns
- **Bootstrap JS**: Load after Popper.js for Bootstrap components
- **Font Awesome**: Use for social icons and UI elements
- **Google Fonts**: Load via `<link>` tags in `<head>`

### File Organization

- **Root**: index.html, app.js, style.css, package.json, vite.config.js
- **Pages**: Subdirectory `pages/` for secondary HTML pages
- **Images**: Subdirectory `imgs/` for static images
- **Migrations**: `supabase/migrations/` for database schema

### Development Workflow

- **Dev Server**: Run `npm run dev` (Vite)
- **Build**: Run `npm run build` for production
- **Preview**: Run `npm run preview` to preview production build
- **No Framework Migration**: Keep vanilla HTML/CSS/JS unless explicitly requested

## Best Practices

- Use semantic HTML5 elements (header, nav, main, footer, section)
- Maintain accessibility (alt text, aria labels, keyboard navigation)
- Optimize images for web before adding to imgs/
- Test responsive layouts on mobile, tablet, and desktop
- Use meaningful class names that describe purpose, not appearance
- Keep JavaScript minimal and focused on interactivity
- Comment complex logic but keep code self-documenting
