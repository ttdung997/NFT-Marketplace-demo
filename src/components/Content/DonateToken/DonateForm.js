import { useContext, useRef, createRef } from 'react';

import web3 from '../../../connection/web3';
import Web3Context from '../../../store/web3-context';
import CollectionContext from '../../../store/collection-context';
import MarketplaceContext from '../../../store/marketplace-context';
import { formatPrice } from '../../../helpers/utils';

const DonateForm = () => {
  const web3Ctx = useContext(Web3Context);
  const collectionCtx = useContext(CollectionContext);
  const marketplaceCtx = useContext(MarketplaceContext);

  const priceRefs = useRef([]);
  if (priceRefs.current.length !== collectionCtx.collection.length) {
    priceRefs.current = Array(collectionCtx.collection.length).fill().map((_, i) => priceRefs.current[i] || createRef());
  }
  
  const Donate = (event,key) => {
    
    event.preventDefault();
    const price = (event.target[1].value).toString();
    marketplaceCtx.contract.methods.Donate().send({ from: web3Ctx.account, value: web3.utils.toWei(price, 'ether')  })
    .on('transactionHash', (hash) => {
      marketplaceCtx.setMktIsLoading(true);
    })
    .on('error', (error) => {
        window.alert('Something went wrong when pushing to the blockchain');
        marketplaceCtx.setMktIsLoading(false);
      }); 
  };
  
 
  return(
          <div className="offset-md-4  col-md-4 card border-info">
            <div className={"card-body"}>       
            </div>                   
                    
                <form className="row g-2" onSubmit={(e) => Donate(e,0)}>                
                  <div className="col-5 d-grid gap-2">
                    <button type="submit" className="btn btn-secondary">Join</button>
                  </div>
                  <div className="col-7">
                    <input
                      type="number"
                      step="0.01"
                      placeholder="ETH..."
                      className="form-control"
                      ref={priceRefs.current[0]}
                    />
                  </div>                                  
                </form> 
                <p><br/></p>
          </div>
       
  );
};

export default DonateForm;