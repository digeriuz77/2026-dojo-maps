import Link from "next/link";

export default function HomePage() {
  return (
    <>
      {/* MAPS Landing Header */}
      <nav className="navbar">
        <div className="container">
          <Link href="/" className="navbar-brand" style={{ display: 'flex', alignItems: 'center', textDecoration: 'none' }}>
            <img src="/maps-logo.svg" alt="MAPS Logo" style={{ height: '40px' }} />
            <div className="logo-text" style={{ marginLeft: '0.75rem' }}>
              <span className="logo-title" style={{ fontWeight: 700, color: 'white', display: 'block' }}>Money & Pensions Service</span>
              <span className="logo-subtitle" style={{ fontSize: '12px', textTransform: 'uppercase', color: 'white', letterSpacing: '0.5px' }}>MAPS LEARNING PLATFORM</span>
            </div>
          </Link>
          <div className="nav-links" style={{ display: 'flex', gap: '1.25rem', alignItems: 'center' }}>
            <Link href="/login" className="nav-link" style={{ color: 'white', textDecoration: 'none', fontWeight: 500 }}>Login</Link>
            <Link href="/register" className="nav-link" style={{ color: 'white', textDecoration: 'none', fontWeight: 500 }}>Register</Link>
          </div>
        </div>
      </nav>

      <main id="app" className="min-h-screen bg-gradient-to-br from-maps-navy via-maps-navy-light to-maps-blue">
        <section className="container mx-auto px-4 py-16">
          <div className="maps-hero-grid grid grid-cols-1 md:grid-cols-2 gap-12 items-center">
            <div className="maps-hero-copy text-left">
              <h1 className="maps-hero-title text-4xl md:text-5xl font-extrabold text-white mb-4" style={{ lineHeight: 1.08 }}>
                Empowering conversations that transform lives
              </h1>
              <p className="maps-hero-subtitle text-white/90 text-lg max-w-2xl mb-6">
                Develop effective coaching skills through realistic practice. The MAPS Learning Platform helps you master collaborative, growth-focused guidance to better support colleagues and clients.
              </p>
              <div className="maps-cta flex flex-wrap gap-4">
                <Link href="/login" className="btn btn-primary btn-lg">
                  Start Training
                </Link>
                <Link href="/about" className="btn btn-outline btn-lg" style={{ color: 'white', borderColor: 'white' }}>
                  Learn More
                </Link>
              </div>
            </div>

            <div className="maps-hero-visual relative h-80 md:h-full" aria-label="Hero Visual">
              <div className="conversation-overlay absolute right-0 top-0 bg-white rounded-lg border border-gray-200 shadow-lg p-4 w-80" >
                <div className="overlay-label font-semibold text-sm uppercase mb-1" style={{ color: '#374151' }}>COACHEE PERSONA</div>
                <div className="overlay-quote mb-2 text-sm" style={{ color: '#374151' }}>"I feel overwhelmed with the new project timeline."</div>
                <div className="overlay-label font-semibold text-sm uppercase mt-2" style={{ color: '#374151' }}>YOU (COACH)</div>
                <div className="overlay-quote text-sm" style={{ color: '#374151' }}>"What support would be most helpful for you right now?"</div>
                <div className="tag-badge mt-2 inline-block bg-gray-100 text-xs px-2 py-1 rounded" style={{ border: '1px solid #e5e7eb' }}>
                  ✓ Open-ended Question
                </div>
              </div>
            </div>
          </div>
        </section>

        <section className="blue-banner py-8" style={{ background: 'linear-gradient(135deg, #1e90ff 0%, #0a62d9 100%)', color: 'white' }}>
          <div className="container mx-auto px-4">
            <h2 className="section-title inline-block" style={{ fontSize: '1.5rem', fontWeight: 800, borderBottom: '4px solid #f472b6', paddingBottom: '6px' }}>
              Our Commitment
            </h2>
            <p className="mt-4 max-w-3xl" style={{ color: 'white', opacity: 0.95 }}>
              At the Money and Pensions Service, we are committed to giving the right guidance at the right time. This platform allows us to care for our colleagues and the people we serve by honing the skills needed to empower others to find their own solutions.
            </p>
          </div>
        </section>
      </main>
    </>
  );
}
