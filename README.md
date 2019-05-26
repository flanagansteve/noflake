This is a smart contract that forces people to stake ETH on scheduling commitments, facing potential penalty for cancellations or rescheduling. Its goal is to overcome the innate awkwardness of holding your peers accountable to their scheduling commitments by substituting social capital lost/gained from good scheduling etiquette with actual financial capital. It follows the following incentive system:

User Interactions:
- Users set a default ETH per minute rate for inviting them to a meeting

- Meeting inviter pays that amount to get a meeting with the user, and can raise the stake size based on the meetings importance; the recipient will match them to accept

Outcomes:
- Inviter cancels before recipient accepts, or recipient rejects: ETH returns to inviter

- Recipient accepts and meeting proceeds as planned: ETH returns to both parties equally

- Recipient accepts but cancels: Inviter gets their ETH back, plus a hard-coded portion of the recipients

- Recipient accepts but reschedules: Inviter gets their ETH back, plus a configurable portion of the recipients

- Inviter cancels after recipient accepts: Recipient gets their ETH back, plus a hard-coded portion of the inviters; likely a higher portion than when the recipient cancels, since the inviter cancelling is ruder

- Inviter reschedules after recipient accepts: Recipient gets their ETH back, plus a configurable portion of the recipients

You'll notice that this contract also elegantly allows people to configure the importance of an invitation, a nice side-feature that could be expanded to create a system of financially backed social interactions as investments.
