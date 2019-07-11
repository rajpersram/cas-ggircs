import React from 'react'
import Head from 'next/head'

const Header = () => {
  return (
      <React.Fragment>
          <Head>
              <meta name="viewport" content="width=device-width, initial-scale=1" />
              <meta charSet="utf-8" />
              <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
                    integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm"
                    crossOrigin="anonymous" />

          </Head>
          <header>
              <div className="banner">
                  <a href="https://gov.bc.ca" alt="British Columbia">
                      <img src="/static/logo-banner.png"
                           alt="Go to the Government of British Columbia website" />
                  </a>
                  <h1>GGIRCS Industry Portal</h1>
              </div>
              <div className="other">
                  &nbsp;
              </div>
              <style jsx>{`
                header {
                  background-color: #036;
                  border-bottom: 2px solid #fcba19;
                  padding: 0 65px 0 65px;
                  color: #fff;
                  display: flex;
                  height: 65px;
                  top: 0px;
                  //position: fixed;
                  width: 100%;
                  margin-bottom: 40px;
                }

                header h1 {
                  font-family: ‘Noto Sans’, Verdana, Arial, sans-serif;
                  font-weight: normal;  /* 400 */
                  margin: 5px 5px 0 18px;
                  visibility: hidden;
                }

                header .banner {
                  display: flex;
                  justify-content: flex-start;
                  align-items: center;
                  margin: 0 10px 0 0;
                  /* border-style: dotted;
                  border-width: 1px;
                  border-color: lightgrey; */
                }

                header .other {
                  display: flex;
                  flex-grow: 1;
                  /* border-style: dotted;
                  border-width: 1px;
                  border-color: lightgrey; */
                }

                /*
                  These are sample media queries only. Media queries are quite subjective
                  but, in general, should be made for the three different classes of screen
                  size: phone, tablet, full.
                */

                @media screen and (min-width: 600px) and (max-width: 899px) {
                  header h1 {
                    font-size: calc(7px + 2.2vw);
                    visibility: visible;
                  }
                }

                @media screen and (min-width: 900px) {
                  header h1 {
                    font-size: 2.0em;
                    visibility: visible;
                  }
                }
              `}</style>
          </header>
      </React.Fragment>
  )
}

export default Header